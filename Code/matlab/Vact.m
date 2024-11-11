clear all;



% data import from previous codes
I_act = 1.0e-05 * [0.5992    0.4908    0.6078    0.6927    0.6377    0.6299];
V_act = [1.5538    1.5952    1.6342    1.9949    2.3165    2.6478];
s_v = repelem(0.05, length(V_act));
ufl = [629.9471  611.6782  593.7855  526.7789  460.6394  399.2741];%nm
gaml = 1e-5 * [1.6444    2.0878    1.7625   4.1198    3.5799    3.3395];
l_ = 1./ufl;

% phyical constants
c = 299792458 * 1e9; %nm/s
h = 4.035667 * 1e-15;

% fitting data using linear model, added member should be caused by fondoscala error of the photodiode

function y = lin(params, x)
  y = params(1)*x + params(2);
end
p0 = [1240, 0];
[beta, R, ~, covbeta] = nlinfit(l_, V_act, @lin, p0);





k = 0;
for i = 1:length(R)
    k = k + R(i)^2/s_v(i)^2;
end
k = k/(length(ufl)-2);
k



beta(1);
sqrt(covbeta(1, 1));

h_ = beta(1)/c;
err_h = h_ * sqrt(covbeta(1, 1)) / beta(1);


h_/h;











t = tiledlayout(2, 1, "TileSpacing","tight", "Padding","tight");
    
% plot of the data, prefit and fit
ax1 = nexttile();

errorbar(l_, V_act, 0.5*s_v, 0.5*s_v, 0.5*gaml, 0.5*gaml, 'o', Color= '#0072BD');hold on

plot(l_, lin(p0, l_), '--', Color = 'cyan');

plot(l_, lin(beta, l_), '-', Color = '#0047AB');


hold off
grid on
grid minor


% residual plots for both fits
ax2 = nexttile();
plot(l_, repelem(0, length(l_)), '--', Color= 'black');
hold on
errorbar(l_, R, 0.5*s_v, 0.5*s_v, 0.5*gaml, 0.5*gaml, 'o', Color= '#0072BD');
hold off
grid on
grid minor



% plot seffings
titleString = " Fit and residuals of ${V_{act}(~70\mathrm{\mu A}}$) against 1/${\lambda }$";
title(t, titleString, "interpreter", "latex");
t.TileSpacing = "tight";
linkaxes([ax1, ax2], 'x');



ylabel(ax1, 'Activation Voltage [V]');



dim = [.06 .65 .3 .3];
dimk = [.06 .55 .3 .3];
str1 = strcat('$ h_{mes} \approx $ ', " ", sprintf('%.2e', h_), " $ \pm $ ", sprintf('%.2e', err_h ), " eV");
str2 = strcat('$ h = $', " ", sprintf('%.2e', h) );
strk = strcat('$ k^2_{red} = $', " ", sprintf('%.2f', k) );
annotation('textbox', dim, 'interpreter','latex','String', [str1 str2],'FitBoxToText','on', 'BackgroundColor', 'white');
annotation('textbox', dimk, 'interpreter','latex','String',strk,'FitBoxToText','on', 'BackgroundColor', 'white');


xlabel(ax2, '${ \lambda^{-1} [1/\mathrm{nm}] }$', 'interpreter', 'latex');
%xlabel(ax2, '${\mu}$','interpreter','latex', 'FontWeight','bold')
ylabel(ax2, 'Activation Voltage - Residuals [V]');



fontsize(14, "points");







