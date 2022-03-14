for tag in 5.4.1 latest
do
    docker build -t rnakato/meme:$tag .
    docker push rnakato/meme:$tag
done
