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
  const code = req.body.code || '';

  const tempFilePath = path.join(__dirname, 'temp.print');
  console.log('Conteúdo que chegou do frontend:', code);

  // Salvar o conteúdo no arquivo temp.print
  fs.writeFileSync(tempFilePath, code);

  // Ler o conteúdo do arquivo temp.print e exibir no console
  const tempFileContent = fs.readFileSync(tempFilePath, 'utf8');
  console.log('Conteúdo do arquivo temp.print:', tempFileContent);

  const parserPath = './parser.exe'; // Caminho relativo
  console.log('Caminho do parser:', parserPath);

  // Construir os argumentos para o comando que será executado
  const commandArgs = ['temp.print'];
  console.log('Comando a ser executado:', `${parserPath} ${commandArgs[0]}`);

  // Executar o parser.exe e capturar a saída
  const childProcess = spawn(parserPath, commandArgs); // Usando parserPath

  let stdoutData = '';
  let stderrData = '';

  childProcess.stdout.on('data', (data) => {
    stdoutData += data;
    console.log(data.toString()); // Exibir a saída no console em tempo real
  });

  childProcess.stderr.on('data', (data) => {
    stderrData += data;
  });

  childProcess.on('exit', (code) => {
    console.log('Código de saída do parser:', code);
    console.log('Saída padrão do parser:', stdoutData);
    console.log('Saída de erro do parser:', stderrData);

    if (code === 0) {
      console.log('Saída do parser:', stdoutData);
      res.json({ result: stdoutData });
    } else {
      console.error('Erro do parser:', stderrData);
      res.status(500).json({ error: 'Erro ao analisar o código.' });
    }

    // Limpeza do arquivo temporário após a finalização do processo
    try {
      fs.unlinkSync(tempFilePath);
      console.log('Arquivo temporário excluído:', tempFilePath);
    } catch (unlinkErr) {
      console.error('Erro ao excluir arquivo temporário:', unlinkErr);
    }
  });
});

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
