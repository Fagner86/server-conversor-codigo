const express = require('express');
const bodyParser = require('body-parser');
const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(bodyParser.json());

app.use(express.static('build'));

app.post('/converter', (req, res) => {
  const codeObject = req.body;
  const code = codeObject.code;
  console.log('chegou aqui', code);
  
    const filePath = path.join(__dirname, 'arquivo.print');
    fs.writeFileSync(filePath, code);
  
    console.log('Code written to arquivo.print');
  
    const parserPath = path.join(__dirname, 'parser.exe');
    console.log('Executing parser.exe:', parserPath);
  
    const parser = spawn(parserPath, [filePath]);
  
    let output = '';
    let isError = false; // Adiciona uma variável para rastrear erros
  
    parser.stdout.on('data', (data) => {
      console.log('Parser output data:', data.toString());
      output += data.toString();
    });
  
    parser.stderr.on('data', (data) => {
      console.error('Parser error:', data.toString());
      isError = true; // Define a variável de erro em caso de erro
    });
  
    parser.on('close', (code) => {
      console.log('Parser process closed with code:', code);
  
      fs.unlinkSync(filePath);
  
      if (isError) {
        // Se houver erro, ainda envie a saída (pode conter parte da saída) para o frontend
        res.send(output);
      } else {
        // Se não houver erro, envie a saída completa para o frontend
        res.send(output);
      }
    });
});


app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});

