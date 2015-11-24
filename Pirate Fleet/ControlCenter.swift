//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    var x: Int
    var y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    
    var cells: [GridLocation] {
        get {
            // Hint: These two constants will come in handy
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            
            // Hint: The cells getter should return an array of GridLocations.
            var occupiedCells = [GridLocation]()
            if length == 2 {
                occupiedCells.append(start)
                occupiedCells.append(end)
            } else if length == 3 {
                var second = start
                if isVertical == true {
                    second.y = start.y + 1
                } else if isVertical == false {
                    second.x = start.x + 1
                }
                occupiedCells.append(start)
                occupiedCells.append(second)
                occupiedCells.append(end)
            } else if length == 4 {
                var second = start
                if isVertical == true {
                    second.y = start.y + 1
                } else if isVertical == false {
                    second.x = start.x + 1
                }
                var third = start
                if isVertical == true {
                    third.y = second.y + 1
                } else if isVertical == false {
                    third.x = second.x + 1
                }
                occupiedCells.append(start)
                occupiedCells.append(second)
                occupiedCells.append(third)
                occupiedCells.append(end)
            } else if length == 5 {
                var second = start
                if isVertical == true {
                    second.y = start.y + 1
                } else if isVertical == false {
                    second.x = start.x + 1
                }
                var third = start
                if isVertical == true {
                    third.y = second.y + 1
                } else if isVertical == false {
                    third.x = second.x + 1
                }
                var fourth = start
                if isVertical == true {
                    fourth.y = third.y + 1
                } else if isVertical == false {
                    fourth.x = third.x + 1
                }
                occupiedCells.append(start)
                occupiedCells.append(second)
                occupiedCells.append(third)
                occupiedCells.append(fourth)
                occupiedCells.append(end)
            }
        return occupiedCells
        }
    }
    

    var hitTracker: HitTracker
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    var sunk: Bool {
        var wasSunk = true
        for (_, value) in hitTracker.cellsHit {
            wasSunk = wasSunk && value
        }
        return wasSunk
    }

// TODO: Add custom initializers
    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = false
        self.hitTracker = HitTracker()
    }
    
    init(length: Int, location: GridLocation, isVertical: Bool, isWooden: Bool) {
        self.length = length
        self.location = location
        self.isVertical = isVertical
        self.isWooden = isWooden
        self.hitTracker = HitTracker()
    }
    
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteedHit: Bool {get}
    var penaltyText: String {get}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    let location: GridLocation
    let guaranteedHit: Bool
    let penaltyText: String
    
    init(location: GridLocation, penaltyText: String) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteedHit = false
    }
    
    init(location: GridLocation, penaltyText: String, guaranteedHit: Bool) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteedHit = guaranteedHit
    }

}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    let guaranteedHit: Bool
    let penaltyText: String
}

class ControlCenter {
    
    func placeItemsOnGrid(human: Human) {

//        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: false, hitTracker: HitTracker())
        
        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true)
        human.addShipToGrid(smallShip)
        
        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, isWooden: true)
        human.addShipToGrid(mediumShip1)
        
        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, isWooden: true)
        human.addShipToGrid(mediumShip2)
        
        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: true)
        human.addShipToGrid(largeShip)
        
        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true)
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine(location: GridLocation(x: 6, y: 0), penaltyText: "KA-BOOM!")
        human.addMineToGrid(mine1)
        
        let mine2 = Mine(location: GridLocation(x: 3, y: 3), penaltyText: "KA-BOOM!", guaranteedHit: true)
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6), guaranteedHit: true, penaltyText: "Seaamonsterrr!!")
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2), guaranteedHit: true, penaltyText: "Seaamonsterrr!!")
        human.addSeamonsterToGrid(seamonster2)
    
    }
    
    func calculateFinalScore(gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}