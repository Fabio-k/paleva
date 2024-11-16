# Palevá

![static badge](https://img.shields.io/badge/Ruby_3.3.2-CC342D?logo=ruby)
![static badge](https://img.shields.io/badge/tailwind-94a3b8?logo=tailwindcss)
![Static Badge](https://img.shields.io/badge/STATUS-EM_DESENVOLVIMENTO-green)

## Descrição do projeto

Palevá é um sistema de gerenciamento de pedidos para restaurantes do tipo Take Away. Ele permite que os restaurantes gerenciem seus pedidos de forma eficiente, desde a criação do pedido até a entrega.

[link para o gerenciador de pedidos](https://github.com/Fabio-k/paleva-vue)

## Pré Requisitos

- Ruby v3.3.2
- Rails v7.2.1.1
- SQLite

## Como rodar o projeto

- Clone o repositório

```bash
git clone https://github.com/Fabio-k/paleva.git
```

- Abra o diretório pelo terminal

```bash
cd paleva
```

- instale as dependências

```bash
bundle install
```

- Crie e popule o banco de dados

```bash
rails db:migrate
rails db:seed
```

- Execute a aplicação

```bash
bin/dev
```

- acesse a aplicação no link http://localhost:4000/

## Usuários Disponíveis pelo seed

| Tipo de Usuário | Email            | Senha         |
| --------------- | ---------------- | ------------- |
| Admin           | victor@email.com | senha123senha |
| Employee        | rafael@email.com | senha123senha |
