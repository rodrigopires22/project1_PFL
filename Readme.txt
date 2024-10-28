Rodrigo Pires up202207292 50% - Desenvolveu as features pathDistance, rome, adjacentCity, travelSales e isValidPath
Afonso Mansilha  up202206002  50%  - Desenvolveu as features Cities, areAdjacent, isStronglyConnected e shortesPath e as funções auxiliares adjacentCity, bfs, dfs e dfsHelper

**shortestPath**

  Para a função shortestPath começamos por definir o caso em que é pedido o camino mais curto ente uma cidade e ela mesma, se este não fosse o caso utilizamos as funções bfs( recebe uma cidade como ponto de partida e faz uma Breadh-First Search), adjacent(já definidaa) e pathDistance (já definida) como funções auxiliares para conseguirmos identificar o(s) caminho(s) mais curtos entre as cidades fornecidas 
  A função bfs utiliza a recursão e a função adjacent para percorrer o roadMap até detetar um caminho. Se não existir nenhum caminho possível retorna 0, caso contrário utiliza a função pathDistance para determinar a distância do mesmo e compará-la com a distância mínima (que começa com max distance):
        -se for superior descarta o camino e volta a fazer a função à procuro de um novo,
        -se for inferior a função é retornada ,mas com este camino como o mais curto,
        -se for igual a a funçaõ é retornada, mas com este camino acresentado a lista dos mais curtos (sem descartar os outros equivalentes).
  Por fim, quando já não recebe mais caminhos, dá return ao(s) caminho(s) mais curto(s). 

**pathDistance**

A função pathDistance tem o objetivo de calcular a distância total percorrida ao seguir um caminho específico (uma sequência de cidades) em um RoadMap. Ela funciona de maneira recursiva, verificando se cada par consecutivo de cidades no caminho está conectado por uma estrada. Para cada par de cidades, usa a função auxiliar distance para verificar se há uma estrada e qual a sua distância. Se todas as cidades estiverem conectadas, a função soma todas as distâncias e retorna o total em formato Just. Caso encontre uma desconexão (ou seja, se não houver estrada entre duas cidades consecutivas), a função retorna Nothing, indicando que o caminho é inválido. Essa função é importante para calcular o custo total de um caminho, por exemplo, no problema do "Traveling Salesman".
