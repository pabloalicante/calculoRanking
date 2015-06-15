function L=informacion_incompleta(ListaM)
[x,n]=size(ListaM{1});
num_max=size(ListaM);

%Lista para introducir elementos con informacion incompleta.
%Van en orden natural como construimos el problema de programacion lineal.
L=[];
%Numero matriz
m = 1;
%Contador de elementos
cont = 1;
while(m <= num_max(2))
    for i=1:n
        for j=i+1:n
            if ListaM{m}(i,j) == -1
                L = [L; cont];
            end
            cont = cont+1;
        end
    end
    m = m+1;
end
            