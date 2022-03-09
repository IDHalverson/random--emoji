const express = require("express");
const app = express();
const fs = require("fs");
const path = require("path");

app.use(express.static('public'));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');
app.set('port', (process.env.PORT || 3000));

const randomChoice = (list) => {
    return list[Math.floor(Math.random()*list.length)];
}

app.get("/emoji", (req, res) => {
    const fileContents = fs.readFileSync("emoji_list.txt").toString();
    const oneEmoji = randomChoice(Array.from(fileContents.match(/:[a-zA-Z0-9\-\+\_]+:/g)));
    const filesInDir = fs.readdirSync("public/emojis");
    const oneEmojiFileNameMainPart = oneEmoji.replace(/^:/, "").replace(/:$/, "");
    const filename = filesInDir.find(filename => filename.match(new RegExp(`^${oneEmojiFileNameMainPart}.`)));
    res.render("index", {
        emojiPath: `emojis/${filename}`,
        emojiName: oneEmoji,
        emojiNameRaw: oneEmojiFileNameMainPart
    });
})

const server = app.listen(process.env.PORT || 3000, () => {
    console.log("App is running.")
})