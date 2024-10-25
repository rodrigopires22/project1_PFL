import qualified Data.List
import qualified Data.Array
import qualified Data.Bits

-- PFL 2024/2025 Practical assignment 1

-- Uncomment the some/all of the first three lines to import the modules, do not change the code of these lines.

type City = String
type Path = [City]
type Distance = Int

type RoadMap = [(City,City,Distance)]

cities :: RoadMap -> [City]
{-Para esta função nós usamos uma Comprension List para percorrer todas as cidades do road map, concatenado-as numa lisat com a função concat. 
Para retirar os duplicados usamos a função nub do Data.List-}

cities r = Data.List.nub (concat [[c1,c2] | (c1,c2,d) <- r])  

areAdjacent :: RoadMap -> City -> City -> Bool

areAdjacent [] _ _ = False

areAdjacent ((c1, c2, _):rs) city1 city2 
    |(c1 == city1 && c2 == city2) || (c1 == city2 && c2 == city1)  = True
    |otherwise = areAdjacent rs city1 city2


pathDistance :: RoadMap -> Path -> Maybe Distance
pathDistance _ [] = Just 0
pathDistance _ [_] = Just 0
pathDistance roadmap (c1:c2:cs) = case distance roadmap c1 c2 of
    Nothing -> Nothing
    Just d  -> case pathDistance roadmap (c2:cs) of
        Nothing -> Nothing
        Just ds -> Just (d + ds)

distance :: RoadMap -> City -> City -> Maybe Distance
distance roadmap city1 city2 = 
    case [(d) | (c1, c2, d) <- roadmap, (c1 == city1 && c2 == city2) || (c1 == city2 && c2 == city1)] of
        [d] -> Just d
        _   -> Nothing



adjacent :: RoadMap -> City -> [(City, Distance)]
adjacent roadmap city = [(c2, d) | (c1, c2, d) <- roadmap, c1 == city] ++ [(c1, d) | (c1, c2, d) <- roadmap, c2 == city]


rome :: RoadMap -> [City]
rome roadmap = [city | (city, deg) <- cityDegrees, deg == maxDegree]
  where
    cityDegrees = [(city, length (adjacent roadmap city)) | city <- cities roadmap]
    maxDegree = maximum (map snd cityDegrees)

isStronglyConnected :: RoadMap -> Bool
isStronglyConnected = undefined

shortestPath :: RoadMap -> City -> City -> [Path]
shortestPath = undefined

travelSales :: RoadMap -> Path
travelSales = undefined

tspBruteForce :: RoadMap -> Path
tspBruteForce = undefined -- only for groups of 3 people; groups of 2 people: do not edit this function

-- Some graphs to test your work
gTest1 :: RoadMap
gTest1 = [("7","6",1),("8","2",2),("6","5",2),("0","1",4),("2","5",4),("8","6",6),("2","3",7),("7","8",7),("0","7",8),("1","2",8),("3","4",9),("5","4",10),("1","7",11),("3","5",14)]

gTest2 :: RoadMap
gTest2 = [("0","1",10),("0","2",15),("0","3",20),("1","2",35),("1","3",25),("2","3",30)]

gTest3 :: RoadMap -- unconnected graph
gTest3 = [("0","1",4),("2","3",2)]