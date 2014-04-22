sudo add-apt-repository ppa:builds/sphinxsearch-rel21

sudo apt-get update

sudo apt-get install sphinxsearch

rake ts:index

rake ts:start