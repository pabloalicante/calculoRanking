function ResiduoTotal=residuos(ListaM,rank,normaIndividual,discrepanciaGrupal)

[n,~] = size(ListaM{1});
%Armo matriz ideal
W = [];
for i=1:n
    for j=1:n
        if(i==j)
            W(i,j) = 0.5;
        elseif(i<j)
            W(i,j) = 0.5*(rank(i)-rank(j)+1);
        else
            W(i,j) = 1-W(j,i);
        end
    end
end

%Lista de residuos
sizeM = size(ListaM);
ListaResiduos = cell(1, sizeM(2));

if nargin == 3
    %Elijo norma discrepante entre cada experto individualmente
    if normaIndividual == 1
        for i=1:sizeM(2)
            ListaResiduos{i} = norm(ListaM{i}-W,1);
        end
        
        
    elseif strcmp(normaIndividual,'fro')
        for i=1:sizeM(2)
            ListaResiduos{i} = norm(ListaM{i}-W,'fro');
        end
        
    elseif strcmp(normaIndividual,'inf')
        for i=1:sizeM(2)
            ListaResiduos{i} = norm(ListaM{i}-W,inf);
        end
    else
        error('Normas individuales posibles: 1, ''fro'', ''inf''');
    end
else
    for i=1:sizeM(2)
        ListaResiduos{i} = norm(ListaM{i}-W,'fro');
    end
end
%Elijo satisfaccion (residuo grupal)
if nargin == 4
    if discrepanciaGrupal == 1
        ResiduoTotal = sum([ListaResiduos{:}]);
    elseif strcmp(discrepanciaGrupal,'inf')
        ResiduoTotal = max([ListaResiduos{:}]);
    else
        error('Normas grupales posibles: 1, ''inf''')
    end
else
    ResiduoTotal = max([ListaResiduos{:}]);
end

%Mostramos grafica para visulizar los errores de cada experto
ini = [1 0 0];
fin = [0 1 0];
for k = 1:32
    t = (k-1)/31;
    cmap(k,:) = ini*(1-t)+fin*t;
end
for i=1:sizeM(2)
    figure;
    imagesc(abs(ListaM{i}-W))
    colormap(cmap)/colormap(gray);
end


