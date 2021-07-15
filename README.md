# Desafio Funcional

Desafio proposto para o cargo Analista de Infra Cloud.

## Description

Projeto usando as tecnologias Terraform, Ansible e Kubernetes.

## Começando

### Dependências
Algumas ferramentas precisam ser instaladas previamente, caso já não estejam.

-> Terraform : 
https://learn.hashicorp.com/tutorials/terraform/install-cli

-> AWS Cli version 2 : 
https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html

-> Ansible : 
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html


-> Dependências do Ansible : 
community.general , ansible.posix

Existe um script dentro da pasta funcional-desafio/ansible/script/ chamado dependency.sh que efetua a instalação das dependências.

-> Caso esteja utilizando o sistema operacional windows, recomendo a utilização do WSL2 para simular uma distro Linux a sua escolha dentro do windows e efetuar a instalação do Ansible nela.

-> WSL2 : 
https://docs.microsoft.com/pt-br/windows/wsl/install-win10


### Executando Terraform

O arquivo terraform.tfstate está ignorado pelo git pois o mesmo está em um bucket na s3 como backup, conforme podem visualizar no arquivo main.tf. O bloco de código está comentado e se quiser replicar basta criar um bucket na s3 e inserir as informações necessárias no código.

O arquivo terraform.tfvars está ignorado pelo git por motivos de segurança, pois será nele que botaremos as informações sensíveis (aws access key, aws secret key e etc.).

Crie um arquivo terraform.tfvars dentro da pasta terraform, para popular as variáveis que usaremos no arquivo vars.tf.
As variáveis a serem populadas são:
- aws_access_key
- aws_secret_key
- aws_region
- aws_availability_zone
- aws_instance_name
- aws_instance_type
- ami
- key_name
- keypair

Antes de executar os comandos do terraform, é necessário popular as variáveis acima e criar um par de chaves rsa.

**Criando par de chaves no Linux:**
- ssh-keygen -t rsa
- Insira o local aonde deseja salvar a chave
- Insira uma senha para acessar a chave

Esse processo gerará 2 arquivos. id_rsa e id_rsa.pub. A chave privada (que ficará com você) é a id_rsa.A chave pública,que é a id_rsa.pub, deverá ser inserida no campo keypair do arquivo terraform.tfvars. Basta dar um cat id_rsa.pub aonde criou a chave para poder copiar o texto para o arquivo .tf.

Para criar chaves RSA no windows, há algumas maneiras diferentes. Deixo o link abaixo para consulta.
https://phoenixnap.com/kb/generate-ssh-key-windows-10

Depois de popular o arquivo terraform.tfvars que criou e efetuar a criação da chave rsa, navegue pelo seu terminal de preferência até a pasta terraform. Dentro dela encontram-se todos os arquivos necessários para subir a infraestrutura solicitada.

- Execute o comando terraform init para inicializar o terraform na pasta.
- Execute o comando terraform validate caso queira validar o código.
- Execute o comando terraform fmt nomedoarquivo.tf para formatar o código caso tenha feito alguma alteração e não sabe se a identação dos arquivos está correta.
- Execute o comando terraform plan para que o terraform mostre um plano de tudo que será criado utilizando os arquivos da pasta terraform
- Execute o comando terraform apply para provisionar a infraestrutura. Ele pedirá uma resposta yes depois de alguns segundos caso realmente queira prosseguir. Caso não deseje prosseguir basta digitar qualquer outra coisa. 

### Executando Ansible
Os arquivos secret-vars.yaml e a chave rsa estão ocultos para o git por motivos de segurança. Foi deixado um arquivo .example no lugar do secret-vars.

Navegue até a pasta do ansible no projeto. Lá você irá encontrar os seguintes arquivos:
- Pasta Scripts, contendo os scripts de backup e de dependecys.
- O arquivo backup.yaml
- O arquivo configuracao.yaml
- O arquivo hosts.yaml
- O arquivo index.html
- O arquivo secret-vars.yaml.example

Usar o output gerado pelo terraform com o IP publico da instância criada para popular o arquivo hosts.yaml dentro da pasta do ansible.
Rodar o comando:  ansible-playbook  -i ./hosts.yaml ./configuracao.yaml
Para realizar o backup do disco, basta usar o comando:  ansible-playbook  -i ./hosts.yaml ./backup.yaml


## Authors
Diogo Pereira Caetano dos Santos - 
diogo_caetano@live.com
