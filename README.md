# Como rodar a aplicação

Para rodar a aplicação é necessário ter o Docker instalado na maquina, estar na pasta raiz e executar o comando:

```shell
docker-compose up --build --force-recreate ep-postgres server
```

Então subir o Frontend, na pasta front digitar no terminal

```shell
npm i
npm run start
```

Os exercicios estão na pasta DB