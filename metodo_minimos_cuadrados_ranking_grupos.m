function vector=metodo_minimos_cuadrados_ranking_grupos(varargin)
%varargin: permite definir un numero arbitrario de matrices en tiempo de ejecucion
%nargin: contiene el numero de parametros con el que se llama a la funcion

%Lista de matrices
ListaM = cell(1, nargin);
for i=1:nargin
    ListaM{i} = varargin{i};
end

%Comprobacion de que las matrices son cuadradas y que las dimensiones son las mismas.
dimension = 0;
for i=1:nargin
    [m, n] = size(ListaM{i});
    if(m ~= n)
       error('La matriz %i no es cuadrada',i) 
    end    
    dimension = dimension+n;
end
[n,m] = size(ListaM{1});
if(dimension/nargin ~= n)
    error('Todas las matrices tienen que tener la misma dimensión')
end


tamanio=size(ListaM{1});
filas=tamanio(1);
columnas=tamanio(2);
numEcuaciones=((filas*(columnas-1))/2)*nargin;
matrizSistema=zeros(numEcuaciones, columnas);
%display(numEcuaciones)

vector=[];
contador=1;
    for k=1:nargin
        matriz=ListaM{k};
        for i=1:filas
            for j=1:columnas
                if(i<j)
                    if(matriz(i,j) ~= -1)
                        matrizSistema(contador,i)=1;
                        matrizSistema(contador,j)=-1;
                        vector=[vector (2*matriz(i,j)-1)];
                    else
                        vector=[vector 0];
                    end
                    contador=contador+1;
                end
            end
        end
    end
      
    %display(matrizSistema);
    %display(vector);
    pesos=matrizSistema\vector';
    %display(pesos);
    minimo=min(pesos);
    if(minimo<0)
        pesos=pesos+abs(minimo);
    end
    display(pesos);
end