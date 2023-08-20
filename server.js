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
  let isError = false;
  console.log('Code written to arquivo.print');

    if (isError) {
      res.send(code);
    } else {
      res.send(code);
    }
});

app.listen(port, () => {
  console.log(`Servidor rodando na porta ${port}`);
});
