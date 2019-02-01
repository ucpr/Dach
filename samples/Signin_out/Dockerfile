FROM nimlang/nim:0.19.0

ADD ./src /testApp

RUN \
  git clone https://github.com/nve3pd/dach ./dach && cd ./dach && git checkout develop && nimble install -y && cd /testApp && rm -r /dach && nim c -d:ssl --run app.nim
