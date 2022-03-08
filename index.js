const express = require("express");
const app = express();
const fs = require("fs");
const path = require("path");

app.use(express.static('public'));
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

const randomChoice = (list) => {
    return list[Math.floor(Math.random()*list.length)];
}

app.get("/emoji", (req, res) => {

    const fileContents = fs.readFileSync("emoji_list.txt").toString();
    const oneEmoji = randomChoice(Array.from(fileContents.match(/:[a-zA-Z0-9\-\+\_]+:/g)));
    console.log("chose:", oneEmoji);
    const filesInDir = fs.readdirSync("public/emojis");
    const oneEmojiFileNameMainPart = oneEmoji.replace(/^:/, "").replace(/:$/, "");
    const filename = filesInDir.find(filename => filename.match(new RegExp(`^${oneEmojiFileNameMainPart}.`)));
    console.log("filename is", filename)

    // const htmlContent = fs.readFileSync("public/index.html").toString();

    // const newHtmlContent = htmlContent.replace(`img src=""`, `img src="emojis/${filename}"`).replace("<h1></h1>", `<h1>${oneEmoji}</h1>`);

    // fs.writeFileSync("public/dynamic-index.html", newHtmlContent);

    res.render("index", {
        emojiPath: `emojis/${filename}`,
        emojiName: oneEmoji
    });
})

const server = app.listen(3000, () => {
    console.log("App is running.")
})