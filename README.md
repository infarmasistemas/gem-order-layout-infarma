##Criando gem

*criar repositório raiz da gem:
order_gem file

*Generate the gem file:
run command "gem build orderInfarma.gemspec" inside the root directory of your gem

*Install the gem:
run "gem install order_gem-0.0.0.gem" or add gem "order" to Gemfile and run blundle install

*Requiring the gem
add "require 'order'"


##Configurar RubyGems para trabalhar com o Frog Artifactory como um repositório rubygem
fonte em: https://jfrog.com/screencast/setting-up-a-rubygems-repository-in-minutes-with-jfrog-artifactory/

*Precondições
Must have a account on JFrog Artifactory and it must be running
Must be logged as administrator and in administrator page


*Passos:

1 - Configurar os repositórios da gem
    *É preciso um repositório local para fazer o deploy a do repositório remoto da gem
    >>Criar um repositório local do tipo gem, se não for possível criar um, utilizar o repositórió para bibliotecas locais OU criar um repositório do tipo genérico e utilizar apenas para subir gems
    (INFARMA já possui o repositório libs-release-local, mas mão para gem's)
    
     - Em Repositories>Local: Clicar em New e escolher o tipo Gems(ou Genérico) OU clicar em repositório já existente
      - Preencher campo Repository Key com 'gems-local', esse será o id do repositório que será pesquisável(browsable under)
      - Clicar em Save & Finish
     
*Criar um proxy para o rubygems.org
      
      -Em Repositories>Remote: Clicar em New e escolher tipo Gems se possível, se não, escolher tipo genérico
      -Preencher o campo Repository key com rubygems e o campo URL que deve apontar para https://rubygems.org
      - Clicar em Save & Finish

*É preciso um repositório virtual para agregar a 'menção' sob um único url> para agrega outros repositório e expor um único URL simples com todo conteúdo de local, remote e outro repositório virtual

    -Em Repositories>Virtual: Clicar em New e escolher o tipo Gems se possível, se não, escolher o tipo genérico
     -Preencher campo Repository Key com all-gems 
    -Selecionar os repositórios a serem incluídos neste repositório virtual
     -Selecionar gems-local e rubygems
     -Clicar em Save & Finish


2 - Permitir que gem possa ser utilizada
*Configurar as ferramentas para trabalhar com Artifactory
    
    -Voltar ao menu principal e clicar em Artifacts
    - Clicar em Set Me Up
    - Em Campo Tool, selecione o tipo do repositório(Gems ou Generic)
    - Em Repository, selecione o repositório all-gems
 
3 - To Upload to JFrog
   curl -i -u<USERNAME>:<PASSWORD> -T <PATH_TO_FILE> "http://artifactory.infarma.com.br/artifactory/gems-local/<TARGET_FILE_PATH>"

4 - To download a file directly using the following command
    curl -i -u<USERNAME>:<PASSWORD> -O "http://artifactory.infarma.com.br/artifactory/gems-local/<TARGET_FILE_PATH>"
