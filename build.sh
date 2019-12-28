for tag in 5.1.0 latest
do
    docker build -t rnakato/meme:$tag .
    docker push rnakato/meme:$tag
done
