const express = require('express');
const bodyParser = require('body-parser');
const { spawnSync } = require('child_process');
const path = require('path'); // Importe o pacote path
const cors = require('cors');

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(bodyParser.json());

app.use(express.static('build'));

app.post('/converter', (req, res) => {
  const code = req.body.code || '';

  const convertedCode = runLexerWithCode(code);

  res.json({ convertedCode });
});

function runLexerWithCode(code) {
  const lexerPath = path.join(__dirname, 'lexer.l'); // Obtenha o caminho absoluto para lexer.l
  const flexProcess = spawnSync('flex', ['-o', 'lex.yy.c', lexerPath], { input: code, cwd: __dirname });

  console.log('chegou aqui o seguinte codigo: ', code);

  if (flexProcess.error) {
    console.error('Erro ao executar o analisador léxico:', flexProcess.error);
    return 'Erro na análise do código';
  } else {
    const gccProcess = spawnSync('gcc', ['lex.yy.c', '-o', 'lexer'], { cwd: __dirname });
    if (gccProcess.error) {
      console.error('Erro ao compilar o lexer:', gccProcess.error);
      return 'Erro na análise do código';
    } else {
      const lexerExeProcess = spawnSync('./lexer', { cwd: __dirname });
      if (lexerExeProcess.error) {
        console.error('Erro ao executar o lexer:', lexerExeProcess.error);
        return 'Erro na análise do código';
      } else {
        const convertedCode = lexerExeProcess.stdout.toString();
        console.log('Converted Code:', convertedCode);
        return convertedCode;
      }
    }
  }
}

app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
