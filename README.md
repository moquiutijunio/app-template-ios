# APP Template iOS

Esse APP é usado para criação de um projeto novo seguindo alguns padrões de desenvolvimento.

 - Login com email e senha seguindo padrões OAuth 2.0
 - Login third part Facebook e Google
 - Login com Apple
 - Esqueci minha senha
 - Cadastro de usuário com: foto, nome, email e senha
 - Placeholder e tratamento de estados de view
 - API RESTfull

## Detalhes técnicos

- Linguagem: Swift
- Versão minima iOS: 10+
- Arquitetura: VIPER + VM + C
- Gerenciador de dependência: Cocoapods
- Padrões de layout: Material designer


## Utilização

Execute o comando no terminal para criar o projeto:

#### Quick start
```bash
git clone https://github.com/moquiutijunio/app-template-ios.git
cd app-template-ios
chmod u+x appGenerator.sh
./generator.sh
```

#### Passo a passo
- Clone o projeto
```bash
git clone https://github.com/moquiutijunio/app-template-ios.git
```

- Vá para o diretório clonado
```bash
cd app-template-ios
```

- Crie o projeto
```bash
chmod u+x appGenerator.sh
./appGenerator.sh
```
    * Se você `não utiliza SSH` use o seguinte comando
    ```bash
    chmod u+x generator.sh
    ./generator.sh -https
    ```

### Configurações

- Em **Assets.xcassets**
    - Adicione o ícone do App em **AppIcon**
    - Na pasta **colors** e em no arquivo **Colors** (para iOS 13+) altere as cores padrões
- Altere a **LaunchScreen** se necessário
- Em **APIClient** altere as URLs base do projeto
- Em **PROJECT** verifique `iOS Deployment Target`
- Em **TARGETS** verifique
    - `Device`
    - `Device orientation`
    - `Status Bar Style`

### Aplicação

<p align="left">
    <img src="https://i.imgur.com/S33Zczd.png" width="200" max-height="50%"/>
    <img src="https://i.imgur.com/0XnzByR.png" width="200" max-height="50%"/>
    <img src="https://i.imgur.com/BOvNaPE.png" width="200" max-height="50%"/>
    <img src="https://i.imgur.com/H3O3Em5.png" width="200" max-height="50%"/>
</p>
