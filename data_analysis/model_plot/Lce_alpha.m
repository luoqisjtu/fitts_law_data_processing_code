

Kpe = 75;
Kse = 136;
alpha = 0:0.3:39;
Lmtu = 0.5:0.01:1.8;
Ka = -2.259*alpha + 117.41;
Lce = Lmtu*Kse./(Kpe + Kse + Ka);

p = polyfit(alpha, Lce, 1)

Lce_line = 0.0206*alpha + 0.1691;

plot(alpha,Lce);hold on;
plot(alpha,Lce_line);


xlabel('alpha')
 ylabel('Lce')