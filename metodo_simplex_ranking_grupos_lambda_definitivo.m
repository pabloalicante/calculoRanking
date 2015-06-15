function rank=metodo_simplex_ranking_grupos_lambda_definitivo(ListaM,lambda,vectorPesos)

if ~iscell(ListaM) 
    error('Primer argumento: matriz M o celda de matrices: {M1,M2,...Mn}');
end

%Numero de matrices pasados en la lista
sizeM = size(ListaM);


%Comprobacion de que las matrices son cuadradas y que las dimensiones son las mismas.
dimension = 0;
for i=1:sizeM(2)
    [m, n] = size(ListaM{i});
    if(m ~= n)
        error('La matriz %i no es cuadrada',i) 
    end    
    dimension = dimension+n;
end
[n,~] = size(ListaM{1});
if(dimension/sizeM(2) ~= n)
    error('Todas las matrices tienen que tener la misma dimensión')
end

numVar = (n*n - n)/2;
f = [(1-lambda)*ones(sizeM(2)*numVar*2,1); zeros(n,1); lambda*1];

%Si le pasamos vector de pesos:
if nargin == 3
    if sum(vectorPesos) ~= 1
        disp('Ojo, tu vector de pesos debería de sumar 1');
    end
    
    sizeV = size(vectorPesos);
    marca = 0;
    for k=1:sizeV(2)
        for i=1:numVar 
            f(i+marca*numVar) = f(i+marca*numVar)*vectorPesos(k);
            f(i+marca*numVar+numVar*sizeM(2)) = f(i+marca*numVar+numVar*sizeM(2))*vectorPesos(k);
        end
        marca = marca+1;
    end
end

Aeq = [];
%Relleno primero los exceso y defectos
for i=1:sizeM(2)*numVar
    j = i;
    aux = zeros(1,sizeM(2)*numVar*2+n+1);
    aux(i) = 1;
    aux(j+sizeM(2)*numVar) = -1;
    Aeq = [Aeq; aux];
end
A = [];
cont = 1;
i = 1;
j = i+1;
%Relleno ahora los wi
while(cont ~= sizeM(2)*numVar+1)
    Aeq(cont, sizeM(2)*numVar*2+i) = -1;
    Aeq(cont, sizeM(2)*numVar*2+j) = 1;
    cont = cont+1;
    j = mod(j+1,n+1);
    if (j == 0)
        i = mod(i+1,n);
        if(i == 0) 
            i = 1;
        end
        j = i+1;   
            
    end
end
cont = 1;
i = 1;
j = i+1;
while(cont ~= numVar+1)
    aux = zeros(1,sizeM(2)*numVar*2+n+1);
    aux(sizeM(2)*numVar*2+i) = 1;
    aux(sizeM(2)*numVar*2+j) = -1;
    aux2 = aux * (-1);
    A = [A ; aux; aux2];
    cont = cont+1;
    j = mod(j+1,n+1);
    if (j == 0)
        i = mod(i+1,n);
        if(i == 0) 
            i = 1;
        end
        j = i+1;
    end
end
for i=1:sizeM(2)*numVar
    j = i;
    aux = zeros(1,sizeM(2)*numVar*2+n+1);
    aux(i) = 1;
    aux(j+sizeM(2)*numVar) = 1;
    aux(end) = -1;
    A = [A; aux];
end    
    
beq = [];
for m=1:sizeM(2)
    for i=1:n
        for j =i+1:n
            aux = -2*ListaM{m}(i,j)+1;%ecuacion
            beq = [beq; aux];
        end
    end
end

b = ones(1,numVar*2)';
b = [b; zeros(1,numVar*sizeM(2))'];

lb = zeros(1,sizeM(2)*numVar*2+n+1)';

%Rellenamos a 0 la informacion incompleta:
L = informacion_incompleta(ListaM);
[tam_incompleta,~]=size(L);

for i=1:tam_incompleta
    iter = L(i);
    f(iter) = 0;
    f(iter+numVar*sizeM(2)) = 0;
   
    Aeq(iter,:) = zeros(1,sizeM(2)*numVar*2+n+1);
    beq(iter) = 0;
end

x = linprog(f,A,b,Aeq,beq,lb);
%ojo que la ultima variable es la D. Las nuestras interesantes son las 3
%anteriores.
rank1 = x(end-(n):1:end-1);
rank = rank1-min(rank1);
end