Para rodar o código, copie e cole o conteúdo de `odd_and_even.pl` em https://swish.swi-prolog.org/ 

Para Induzir a Hipótese execute o seguinte comando no prompt: `?- induce(Hyp).`

Após a hipótese ser gerada, você pode testar consultas diretamente usando a função `?- odd_even_query/2`

Exemplo de Consulta Válida para Lista Ímpar:

`?- odd_even_query([a, b, c], odd).`

`true.`

Exemplo de Consulta Válida para Lista Par:

`?- odd_even_query([a, b, c, d], even)`

`true.`

Testando Casos Inválidos
Se a lista fornecida não corresponder ao tipo esperado, o resultado será false.

`?- odd_even_query([a, b], odd).`

Resultado esperado:

`false.`

**Hipóteses Geradas**:
Essas hipóteses são apenas "esboços" iniciais e não são úteis por si só.

**Hipóteses Refinadas**:
O refinamento adiciona mais conhecimento à hipótese para torná-la específica e útil.

**Hipóteses Finais**:
A hipótese final é a versão mais específica e correta, que deve cobrir todos os exemplos positivos e rejeitar todos os exemplos negativos.


