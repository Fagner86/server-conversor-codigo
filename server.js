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

const filePath = path.join(__dirname, 'arquivo.print'); // Define o caminho do arquivo fora da função de rota

app.post('/converter', (req, res) => {
  const codeObject = req.body;
  const code = codeObject.code;
  console.log('chegou aqui', code);

  fs.writeFileSync(filePath, code); // Sobrescreve o arquivo com o novo conteúdo

  console.log('Code written to arquivo.print');

  const parserPath = path.join(__dirname, './parser.exe');
  console.log('Executing parser.exe:', parserPath);

  const parser = spawn(parserPath, [filePath]);

  let output = '';
  let isError = false;

  parser.stdout.on('data', (data) => {
    console.log('Parser output data:', data.toString());
    output += data.toString();
  });

  parser.stderr.on('data', (data) => {
    console.error('Parser error:', data.toString());
    isError = true;
  });

  parser.on('close', (code) => {
    console.log('Parser process closed with code:', code);

    // Limpa o conteúdo do arquivo, mas mantém o arquivo em si
    fs.writeFileSync(filePath, '');

    if (isError) {
      res.send(output);
    } else {
      res.send(output);
    }
  });
});

app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});
