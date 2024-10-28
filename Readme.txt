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

**rome**

A função rome é responsável por encontrar as cidades com o maior número de estradas conectadas (ou seja, aquelas com o maior "grau"). A função percorre o RoadMap, utilizando a função auxiliar adjacent para calcular quantas estradas partem de cada cidade. Depois, compara esses graus e retorna a lista das cidades que têm o maior número de conexões. Na prática, isso pode ser útil para identificar os principais "hubs" ou centros de tráfego dentro de um mapa de estradas, mostrando quais cidades são mais acessíveis ou possuem maior movimentação. A função usa listas para armazenar o grau de cada cidade e seleciona aquelas com o grau máximo.

**travelSales**

A função travelSales resolve o clássico problema do "Traveling Salesman", em que se busca encontrar o caminho mais curto que permite visitar todas as cidades do RoadMap uma vez e retornar à cidade de origem. A função começa gerando todas as permutações possíveis de cidades (todos os caminhos possíveis) e, para cada permutação, verifica se o caminho é válido usando a função isValidPath. Depois, calcula a distância de cada caminho válido utilizando a função pathDistance e seleciona o caminho com a menor distância total. O travelSales é uma solução de força bruta, pois verifica todas as possíveis combinações de caminhos, sendo útil para problemas de roteamento onde é necessário minimizar o custo (distância) de um percurso que cobre todas as cidades.

**isValidPath**

A função isValidPath é usada para verificar se um caminho (sequência de cidades) é válido, ou seja, se todas as cidades no caminho estão conectadas por estradas diretas. A função percorre o caminho verificando, para cada par consecutivo de cidades, se existe uma estrada entre elas, utilizando a função auxiliar distance. Se todas as conexões existirem, o caminho é considerado válido. Se qualquer uma das conexões estiver faltando, a função retorna False, indicando que o caminho não pode ser percorrido. isValidPath é essencial para garantir que apenas caminhos possíveis sejam considerados em outras funções, como travelSales.

**Funções auxiliares**

-distance: Verifica se há uma estrada entre duas cidades e retorna a distância dessa estrada (ou Nothing se não houver estrada). É usada para validar conexões e calcular distâncias entre cidades.

-adjacent: Retorna uma lista de cidades diretamente conectadas a uma cidade específica, juntamente com as distâncias dessas conexões.
