const fs = require("fs")
const sha256 = require("hash.js/lib/hash/sha/256")
const database = require("./database.json")
// For all the functions, just pass the coordinates (STRING) as the key

// Something to do with the SHA256 function encoding differently with and without braces

// let temp = {}
// for (let i = 12; i < 14; i += 0.005) {
//     for (let j = 76; j < 78; j += 0.005) {
//         let coords = {"x1": j.toFixed(3), "y1": i.toFixed(3), "x2": (j + 0.005).toFixed(3), "y2": (i + 0.005).toFixed(3)}
//         let hashKey = sha256().update(JSON.stringify(coords)).digest("hex")
//         temp[hashKey] = {
//             coordinates: {
//                 x1: 0,
//                 y1: 0,
//                 x2: 0,
//                 y2: 0
//             },
//             safetyIndex: Math.random() * 10,
//             consensusPopulationCount: Math.ceil(Math.random() * 1000)
//         }
//         temp[hashKey].coordinates = {
//             x1: coords.x1,
//             y1: coords.y1,
//             x2: coords.x2,
//             y2: coords.y2
//         } 
//     }
// }
// fs.writeFileSync("./database.json", JSON.stringify(temp), (err) => {
//     if (err) throw err
// })
class HashMap {
    constructor() {

    this.stepSize = {
        x: 0.005,
        y: 0.005
    }
    
    this.defaultObject = {
        coordinates: {
            x1: 0,
            y1: 0,
            x2: 0,
            y2: 0
        },
        rating: 0,
        ratingCount: 0
    }
        this.hashMap = database
    }


    add(coords) {
        let hashKey = sha256().update(JSON.stringify(coords)).digest("hex")
        this.hashMap[hashKey] = this.defaultObject
        this.hashMap[hashKey].coordinates = {
            x1: coords.x1,
            y1: coords.y1,
            x2: coords.x2,
            y2: coords.y2
        }

        //Takes a while to write the data
        fs.writeFileSync("./database.json", JSON.stringify(this.hashMap), (err) => {
            if (err) throw err
        })
    }

    // Just pass it the new rating, it will automatically calculate the new average using the pre-defined method
    // For now, the rating is just the average of all the ratings
    // Pass it the coordinates of the area and the new rating
    updateRating(coords, rating) {
        let hashKey = sha256().update(JSON.stringify(coords)).digest("hex")
        let entry = this.hashMap[hashKey]
        entry.rating = ((entry.rating * entry.ratingCount) + rating) / (entry.ratingCount + 1)
        entry.ratingCount += 1
        fs.writeFileSync("./database.json", JSON.stringify(this.hashMap), (err) => {
            if (err) throw err
        })
    }

    // Pass the coordinates of the touch location on the screen as an object { x: xVal, y: yVal } and it will return the 
    find(coords) {
        let parentCoords = {
            "x1": (coords.x - (coords.x % this.stepSize.x)).toFixed(3),
            "y1": (coords.y - (coords.y % this.stepSize.y)).toFixed(3),
            "x2": ((coords.x - (coords.x % this.stepSize.x)) + this.stepSize.x).toFixed(3),
            "y2": ((coords.y - (coords.y % this.stepSize.y)) + this.stepSize.y).toFixed(3)
        }
        console.log(parentCoords)
        let hashKey = sha256().update(JSON.stringify(parentCoords)).digest("hex")
        return (this.hashMap[hashKey] == null) ? {"error": "Not found"} : this.hashMap[hashKey]
    }
}

exports.HashMap = HashMap
