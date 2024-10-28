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

{-Para esta função nós usamos uma Comprension List para percorrer todas as cidades do road map, concatenado-as numa lista com a função concat. 
Para retirar os duplicados usamos a função nub do Data.List-}

cities r = Data.List.nub (concat [[c1,c2] | (c1,c2,d) <- r])  

areAdjacent :: RoadMap -> City -> City -> Bool

{-Para o areAdjacent usamos condições para returnar True se as 2 cidades fossem adjacentes e False se não fossem -}

areAdjacent [] _ _ = False

areAdjacent ((c1, c2, _):rs) city1 city2 
    |(c1 == city1 && c2 == city2) || (c1 == city2 && c2 == city1)  = True
    |otherwise = areAdjacent rs city1 city2




distance :: RoadMap -> City -> City -> Maybe Distance

{- Para a distance utilizamos a mesma formula da areAdjacent só que para retornar a distancia em vez de um bool -}

distance [] _ _ = Nothing
distance ((c1, c2, d):rs) city1 city2
    | (c1 == city1 && c2 == city2) || (c1 == city2 && c2 == city1) = Just d
    | otherwise = distance rs city1 city2



adjacent :: RoadMap -> City -> [(City, Distance)]

{-Para esta função utilizamos compreensive lists para percorrer todo o roadmap e retirar as cidades adjacentes à cidade dada-}

adjacent r city = ([ (c1, d) | (c1, c2, d) <- r, c2 == city] ++ [(c2, d) | (c1, c2, d) <- r, c1 == city])


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

dfsHelper :: RoadMap -> City -> [City] -> [City]
 {-Função para ajudar a fazer o dfs
 Verificamos se a cidade já está presente na lista dos visitados, 
 se estiver retornamos a lista, se não  acrescentmos a a cidade à 
 lista e utilizamos a recursão para repetir a função com a cidades adjacentes ate verificarmos todas-}
dfsHelper r city visited
      | city `elem` visited = visited 
      | otherwise = foldr (dfsHelper r) (city : visited) (adjacentCity r city)

dfs:: RoadMap -> City -> [City] -- Função para fazer uma dfs
dfs r startCity = dfsHelper r startCity []

    
isStronglyConnected :: RoadMap -> Bool --isStronglyConnected (com ajuda das funções auxiliares em cima) calcula se um roadmap é strongly connected
isStronglyConnected r = all canReach allCities -- Usamos a função all que verifica se todos os elemtos da lista satisfazem a condição (visited) e retorna True se forem todas verdadeiras e False se não forem
  where
    allCities = cities r
    canReach city = length (dfs r city) == length allCities --Verifica se o tamnho da lista visited é igual ao tamanho da lisa do numero total de cidades



-- Encontra todos os caminhos mais curtos entre duas cidades
shortestPath :: RoadMap -> City -> City -> [Path]
shortestPath r start end
    | start == end = [[start]]  -- Caso base: o caminho mais curto de uma cidade para ela mesma é a própria cidade
    | otherwise = bfs [[start]] [] maxDistance
  where
    maxDistance = 10^6  -- Define uma distância "máxima" alta para representar infinitos
    -- BFS para encontrar todos os caminhos mais curtos
    bfs :: [Path] -> [Path] -> Distance -> [Path]
    bfs [] shortestPaths _ = shortestPaths  -- Sem mais caminhos para explorar
    bfs (p:ps) shortestPaths minDist
        | last path == end =
            case pathDistance r p of
                Nothing -> bfs ps shortestPaths minDist  -- Ignora caminhos inválidos
                Just d  ->
                    if d < minDist
                    then bfs ps [p] d  -- Novo caminho mais curto encontrado
                    else if d == minDist
                         then bfs ps (p : shortestPaths) minDist  -- Outro caminho com a mesma distância mínima
                         else bfs ps shortestPaths minDist
        | otherwise =
            let nextCities = [city | (city, _) <- adjacent r (last path), city `notElem` path]
                newPaths = [path ++ [next] | next <- nextCities]
            in bfs (paths ++ newPaths) shortestPaths minDist

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