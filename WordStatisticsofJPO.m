%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WARNING：Do not use this code illegally !
% RISK:    IP blocked by website administrator.

% Description
% en: Similarly, word frequency statistics can be conducted as long as
%     you are able to access full article.
% zh: 亦可爬论文全文，做词频统计。

% Note:
% Windows code.
% MATLAB R2017b or newer and associated Text Analytics Toolbox are required.
% full text of article accessful is required.

% Author: github.com/chouj

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Target journal url
pre='https://journals.ametsoc.org';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% web crawling %%%%%%%%%%%%%%%%%%%%%%%%%%%
text=' '; % get text string prepared

for volume=27:47 % for instance, can be modified
    for month=1:12 % for instance, can be modified
    
        % Dynamic webpage, thus urlread/webread will fail.
        try
            [a1, h1] = web(['https://journals.ametsoc.org/toc/phoc/',num2str(volume),'/',num2str(month)]);
            pause(60);
        catch
            [a1, h1] = web(['https://journals.ametsoc.org/toc/phoc/',num2str(volume),'/',num2str(month)]);
            pause(60);
        end
        htmlText1 = get(h1, 'HtmlText');  % Gives you html content of current page
        
        clear t
        % Give you urls of each article
        t = regexp(htmlText1,'<a class="ref nowrap full" href="(.*?)">Full Text</a>','tokens');
        
        % get text from webpages of each article
        for paper=1:length(t)
            try
                [a2, h2] = web([pre,t{paper}{1}]);
                
            catch
                pause(60);
                [a2, h2] = web([pre,t{paper}{1}]);
            end
            
            pause(15);
            htmlText2 = get(h2, 'HtmlText');  % Gives you html content of current page
            
            clear str
            str = extractHTMLText(htmlText2); % extract text from html code
            text=strcat(text,str); % collect text
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%% Word Cloud Generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
document = tokenizedDocument(lower(text));
document = removeWords(document,stopWords);
document = erasePunctuation(document);

% Remove words you dislike
document = removeWords(document,["1997","figure","figures","fig","version",...
    "direct","view","equation","shown","level",...
    "scholarship","b","variable","section","introduction","conclusion","discussion",...
    "term","h","d","1","2","3","4","5","6","7","8","9","google","t","w","all","north","south",...
    "west","east","effect","phase","m","s","two","one","case","different","differ","k","first",...
    "ocean","physical","oceanography","e","n","due","etc","study","10",...
    "r","change","increase","decrease","mean","average","time","field","number","generate",...
    "generation","data","present","condition","larger","large","heat","layer",...
    "choosetop","pageabstract1","fram","model3","o","cycle5","processese","values","period","1993",...
    "1995","near","table","equations","j","shows","km","maximum","part","f","x","u","g","15","same",...
    "et","al","0","found","sv","res","l","small","20","phys","oceanogr","terms","order","thus","1992",...
    "total","similar","1994","strong","well","less","1989","geophys","12","respectively","c","associated",...
    "relative","below","line","form","motion","depth","results","result","1996","1991",...
    "conditions","30","speed","speeds","z","y","p","calculated","13","component","z","zero","analysis","point",...
    "although","however","show","changes","three","error","positive","negative","fields","references",...
    "appendix","scholar","function","value","side","high","low","higher","1982","based","lower","series",...
    "sea","25","cm","obtained","11","comparison","constant","genreal","figs","southern","northern","eastern",...
    "western","described","area","1987","system","second","1988","important","reference","range",...
    "westward","general","eg","smaller","example","oceanic","1990","box","cases","days","state",...
    "consistent","problem","long","note","corresponding","northward","sections","net","compared","o","¦Á",...
    "¦Á","equational","articles","defined","v","following"]);

% cleardocument = normalizeWords(document);
bag = bagOfWords(document);wordcloud(bag);
