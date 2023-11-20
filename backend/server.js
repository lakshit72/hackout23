const express = require("express")
const hashMapFile = require("./HashMap")
const PORT = process.env.PORT || 3000

// ---------------START OF DUMMY DATA--------------------------

let rating = 4
// -----------------END OF DUMMY DATA--------------------------

const hashMap = new hashMapFile.HashMap()

const server = express()

server.use(express.json())

server.post("/find", (req, res) => {
    console.log(req.body)
    let touchLocation = {x: req.body.longitude, y: req.body.latitude}
    response = hashMap.find(touchLocation)
    console.log(response)
    res.end(JSON.stringify(response))
})

// EXAMPLE: hashMap.updateRating( hashMap.find(touchLocation).coordinates, 5 )
server.listen(3000, () => console.log(`Server Started on PORT ${PORT}`))