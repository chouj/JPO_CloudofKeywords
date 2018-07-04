%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WARNING：Do not use this code illegally !

Note:
Windows code.
MATLAB R2018a or newer and associated Text Analytics Toolbox are required.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Target journal
pre='https://journals.ametsoc.org';

% get proxy IPs
% Thangks to https://github.com/a2u/free-proxy-list
urlwrite('https://proxy.l337.tech/txt','{YourFolder}\p.txt');
pp=importdata('{YourFolder}\p.txt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% web crawling %%%%%%%%%%%%%%%%%%%%%%%%%%%
documents = cell(1); % cell array for keywords
for issue=43:47 % for instance, can be modified
    for month=1:12 % for instance, can be modified
        pause(15);
        disp(['V',num2str(issue),' - I',num2str(month)]); 
        pn=randi(length(pp.data),1); % get random proxy IP
        
        % set proxy
        com.mathworks.mlwidgets.html.HTMLPrefs.setUseProxy(true);
        com.mathworks.mlwidgets.html.HTMLPrefs.setProxyHost(pp.textdata{pn});
        com.mathworks.mlwidgets.html.HTMLPrefs.setProxyPort(num2str(pp.data(pn)));
        
        % Dynamic webpage, thus urlread/webread will fail.
        try
            [a1, h1] = web(['https://journals.ametsoc.org/toc/phoc/',num2str(issue),'/',num2str(month)]);
        catch
            pause(60);
            [a1, h1] = web(['https://journals.ametsoc.org/toc/phoc/',num2str(issue),'/',num2str(month)]);
        end
        
        com.mathworks.mlwidgets.html.HTMLPrefs.setUseProxy(false);
        
        pause(15); % time for loading
        htmlText1 = get(h1, 'HtmlText');  % Give you html content of current page
        clear t
        close(h1);
        
        % Give you urls of each article
        t = regexp(htmlText1,'<a class="ref nowrap abs" href="(.*?)">Abstract</a><span class="articleToolIcon abstractIcon leftSpace"></span>','tokens');
        
        for paper=1:length(t)
            pn=randi(length(pp.data),1);
            com.mathworks.mlwidgets.html.HTMLPrefs.setUseProxy(true);
            com.mathworks.mlwidgets.html.HTMLPrefs.setProxyHost(pp.textdata{pn});
            com.mathworks.mlwidgets.html.HTMLPrefs.setProxyPort(num2str(pp.data(pn)));
            try
                [a2, h2] = web([pre,t{paper}{1}]);
            catch
                pause(60);
                [a2, h2] = web([pre,t{paper}{1}]);
            end
            pause(15);
            htmlText2 = get(h2, 'HtmlText');  % Gives you html content of current page
            close(h2);
            com.mathworks.mlwidgets.html.HTMLPrefs.setUseProxy(false);
            
            % Give you keywords
            clear str
            str = regexp(htmlText2,'<a class="attributes" href="/keyword/.*?">(.*?)</a>','tokens');
            
            % Collecting them
            templength=length(documents);
            for num=1:length(str)
                documents{templength+num}=str{num};
            end
            
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%% Keywords Cloud Generation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(documents)-1;d{i,1}=documents{1,i+1}{1};end
temp=categorical(d);
wordcloud(temp);
title('Keywords Cloud of JPO 2013-2017');
set(gcf,'position',[20 20 800 700]);
print -djpeg wordcloud_jpo_keywords_2013-2017.jpg -r400
print -dtiff wordcloud_jpo_keywords_2013-2017 -r400
