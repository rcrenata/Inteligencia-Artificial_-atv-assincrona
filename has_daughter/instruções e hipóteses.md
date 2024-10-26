Para rodar o carregar o código, copie e cole `has_daughter.pl` em https://swish.swi-prolog.org/ 

Para Induzir a Hipótese execute o seguinte comando no prompt: `?- induce(Hyp).`

Após a hipótese ser gerada, você pode testar consultas diretamente usando a função `has_daughter_query/2.`

Exemplo de Consulta Válida:

`?- has_daughter_query(tom, ann).`

`true.`

**Hipóteses Geradas**: Durante o processo de indução, o sistema imprime as hipóteses intermediárias.

**Hipóteses Refinadas**: Cada vez que uma nova cláusula é adicionada, o sistema mostra o refinamento no console.

**Hipóteses Finais**: A hipótese aprendida é exibida ao final.
