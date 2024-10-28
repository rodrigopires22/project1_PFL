import qualified Data.List
import qualified Data.Array
import qualified Data.Bits

-- PFL 2024/2025 Practical assignment 1

-- Uncomment the some/all of the first three lines to import the modules, do not change the code of these lines.

type City = String
type Path = [City]
type Distance = Int

type RoadMap = [(City,City,Distance)]

-- minimumBy é usado para encontrar o caminho com a menor distância
minimumBy :: (a -> a -> Ordering) -> [a] -> a
minimumBy = Data.List.minimumBy


cities :: RoadMap -> [City]

cities r = Data.List.nub (concat [[c1,c2] | (c1,c2,d) <- r]) --Comprension List para percorrer todas as cidades do road map, função nub do Data.List para retirar duplicados 

areAdjacent :: RoadMap -> City -> City -> Bool

areAdjacent [] _ _ = False

areAdjacent ((c1, c2, _):rs) city1 city2 
    |(c1 == city1 && c2 == city2) || (c1 == city2 && c2 == city1)  = True --Retorna True se as 2 cidades forem adjacentes
    |otherwise = areAdjacent rs city1 city2 --Retorna False se não forem




distance :: RoadMap -> City -> City -> Maybe Distance

distance [] _ _ = Nothing
distance ((c1, c2, d):rs) city1 city2
    | (c1 == city1 && c2 == city2) || (c1 == city2 && c2 == city1) = Just d --Compara as duas cidades para saber se são adjacentes e retorna a distância 
    | otherwise = distance rs city1 city2



adjacent :: RoadMap -> City -> [(City, Distance)] 

adjacent r city = ([ (c1, d) | (c1, c2, d) <- r, c2 == city] ++ [(c2, d) | (c1, c2, d) <- r, c1 == city])--Compreensive lists para percorrer todo o roadmap e retirar as cidades adjacentes à cidade dada 


pathDistance :: RoadMap -> Path -> Maybe Distance
pathDistance _ [] = Just 0 -- Se o caminho for vazio, a distância é 0
pathDistance _ [_] = Just 0 -- Se o caminho contiver apenas uma cidade, a distância é 0
pathDistance roadmap (c1:c2:cs) = case distance roadmap c1 c2 of -- Verifica se há uma estrada direta entre c1 e c2
    Nothing -> Nothing -- Se não houver estrada entre c1 e c2, retorna Nothing (caminho inválido)
    Just d  -> case pathDistance roadmap (c2:cs) of -- Calcula recursivamente a distância do restante do caminho
        Nothing -> Nothing -- Se o restante do caminho for inválido, retorna Nothing
        Just ds -> Just (d + ds) -- Se o restante do caminho for válido, soma a distância atual com a total do restante


rome :: RoadMap -> [City]
rome r = [city | (city, deg) <- cityDegree, deg == maxDegree]
  where
    cityDegree = [(city, length (adjacent r city)) | city <- cities r] -- cityDegree calcula o grau (número de conexões) de cada cidade no RoadMap.
    maxDegree = maximum (map snd cityDegree)-- maxDegree armazena o valor do maior grau encontrado entre as cidades.


adjacentCity :: RoadMap -> City -> [City] -- Função para saber as cidades adjacentes a outra cidade (é igual à função adjacent só que sem a distância)
adjacentCity r city = ([ c1 | (c1, c2, d) <- r, c2 == city] ++ [c2 | (c1, c2, d) <- r, c1 == city])

dfsHelper :: RoadMap -> City -> [City] -> [City] --Função para ajudar a fazer o dfs

dfsHelper r city visited 
      | city `elem` visited = visited -- Verifica se a cidade já está presente na lista dos visitados, se estiver retorna a lista visited
      | otherwise = foldr (dfsHelper r) (city : visited) (adjacentCity r city) --Acrescenta a cidade à lista e usa a recursão para repetir a função com as cidades adjacentes até verificar todas

dfs:: RoadMap -> City -> [City] -- Função para fazer uma dfs
dfs r startCity = dfsHelper r startCity []

    
isStronglyConnected :: RoadMap -> Bool --isStronglyConnected (com ajuda das funções auxiliares em cima) calcula se um roadmap é strongly connected
isStronglyConnected r = all canReach allCities --Função all que verifica se todos os elemtos da lista satisfazem a condição (visited) e retorna True se forem todas verdadeiras e False se não forem
  where
    allCities = cities r
    canReach city = length (dfs r city) == length allCities --Verifica se o tamnho da lista visited é igual ao tamanho da lisa do numero total de cidades




shortestPath :: RoadMap -> City -> City -> [Path]-- Encontra todos os caminhos mais curtos entre duas cidades
shortestPath r start end
    | start == end = [[start]]  --se o path for de uma cidade para a mesma cidade retorna ela mesma
    | otherwise = bfs [[start]] [] maxDistance  --Chama função auxiliar bfs com a cidade inicial e o maxDistance como argumentos
  where
    maxDistance = 10^6  -- Definimos uma distância "máxima" 
    
    bfs :: [Path] -> [Path] -> Distance -> [Path]-- BFS para encontrar todos os caminhos mais curtos
    bfs [] shortestPaths _ = shortestPaths -- Caso base, quando já não houver mais paths dá return ao(s) mais curto(s)
    bfs (path:paths) shortestPaths minDist
        | last path == end =  -- Dá check para ver se o path já foi completado
            case pathDistance r path of -- Chama a função pathDistance para calcular a distância total do caminho path
                Nothing -> bfs paths shortestPaths minDist  -- Ignora os caminhos em que a distância é nothing
                Just d  ->
                    if d < minDist --Compara a distância do path com a distância mínima
                    then bfs paths [path] d  -- Novo caminho mais curto encontrado
                    else if d == minDist
                         then bfs paths (path : shortestPaths) minDist  -- Outro caminho com a mesma distância mínima
                         else bfs paths shortestPaths minDist
        | otherwise =
            let nextCities = [city | (city, _) <- adjacent r (last path), city `notElem` path] --Comprension list e função "adjacente" para percorrer todas as cidades adjacentes que não façam parte do path
                newPaths = [path ++ [next] | next <- nextCities] --Cria um novo path
            in bfs (paths ++ newPaths) shortestPaths minDist --Adiciona newPaths à lista de paths para exploração futura e chama a bfs novamente

travelSales :: RoadMap -> Path
travelSales roadmap = 
  let citiesList = cities roadmap   -- Obtenção da lista de todas as cidades no mapa
      paths = Data.List.permutations citiesList   -- Geração de todas as permutações possíveis das cidades
      validPaths = filter (isValidPath roadmap) paths  -- Filtra os caminhos válidos que conectam todas as cidades
      distances = map (\p -> (p, pathDistance roadmap (p ++ [head p]))) validPaths  -- Calcula a distância de cada caminho e fecha o ciclo retornando à cidade de origem
  in case filter (\(_, d) -> d /= Nothing) distances of
       [] -> []   -- Se não houver caminhos válidos, retorna lista vazia
       ds -> fst (minimumBy (\(_, d1) (_, d2) -> compare d1 d2) ds)   -- Retorna o caminho com a menor distância

-- Função auxiliar que verifica se um caminho é válido (todas as cidades estão conectadas no mapa)
isValidPath :: RoadMap -> Path -> Bool
isValidPath roadmap (c1:c2:rest) = case distance roadmap c1 c2 of
  Nothing -> False
  Just _  -> isValidPath roadmap (c2:rest)
isValidPath _ _ = True


tspBruteForce :: RoadMap -> Path
tspBruteForce = undefined -- only for groups of 3 people; groups of 2 people: do not edit this function

-- Some graphs to test your work
gTest1 :: RoadMap
gTest1 = [("7","6",1),("8","2",2),("6","5",2),("0","1",4),("2","5",4),("8","6",6),("2","3",7),("7","8",7),("0","7",8),("1","2",8),("3","4",9),("5","4",10),("1","7",11),("3","5",14)]

gTest2 :: RoadMap
gTest2 = [("0","1",10),("0","2",15),("0","3",20),("1","2",35),("1","3",25),("2","3",30)]

gTest3 :: RoadMap -- unconnected graph
gTest3 = [("0","1",4),("2","3",2)]