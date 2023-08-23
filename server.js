const express = require('express');
const bodyParser = require('body-parser');
const { exec } = require('child_process');
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
  console.log('Received code:', code);

  fs.writeFileSync(filePath, code); // Sobrescreve o arquivo com o novo conteúdo
  fs.appendFileSync(filePath, '\n');

  console.log('Code written to arquivo.print');

  // Compilar o analisador léxico (Flex)
  exec('flex lexer.l', (error, stdout, stderr) => {
    if (error) {
      console.error('Flex compilation error:', error);
      res.status(500).send('Error during compilation');
      return;
    }

    // Compilar o analisador sintático (Bison)
    exec('bison -d arquivo.y', (error, stdout, stderr) => {
      if (error) {
        console.error('Bison compilation error:', error);
        res.status(500).send('Error during compilation');
        return;
      }

      // Compilar o programa principal
      exec('gcc -o parser arquivo.tab.c -lfl', (error, stdout, stderr) => {
        if (error) {
          console.error('Parser compilation error:', error);
          res.status(500).send('Error during compilation');
          return;
        }

        // Executar o programa com um arquivo de entrada
        exec(`./parser ${filePath}`, (error, stdout, stderr) => {
          if (error) {
            console.error('Execution error:', error);
            res.status(500).send('Error during execution');
            return;
          }

          // Limpa o conteúdo do arquivo, mas mantém o arquivo em si
          fs.writeFileSync(filePath, '');

          res.send(stdout);
        });
      });
    });
  });
});

app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});
