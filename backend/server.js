const http = require("http")
const hashMapFile = require("./HashMap")
const PORT = process.env.PORT || 3000

// ---------------START OF DUMMY DATA--------------------------
let touchLocation = {
    x: 221.212122,
    y: 442.424244
}
let rating = 4
// -----------------END OF DUMMY DATA--------------------------

const hashMap = new hashMapFile.HashMap()

const server = http.createServer( ( req, res ) => {
    if (req.url == "/add") {
        console.log(req.headers)
        res.end()
    }

    else if (req.url == "/updateRating") {
        
    }

    else if (req.url == "/find") {
        
    }
})

// EXAMPLE: hashMap.updateRating( hashMap.find(touchLocation).coordinates, 5 )

server.listen(PORT, () => {
    console.log(`Server Started on PORT ${PORT}`)
} )

