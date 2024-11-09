I_act = 1.0e-05 * [0.5992    0.4908    0.6078    0.6927    0.6377    0.6299];

V_act = [1.5538    1.5952    1.6342    1.9949    2.3165    2.6478];

uf = [629.6702  611.3691  593.5095  527.4875  461.0542  399.2358];

sf = [7.1507    8.8193    6.9178   12.6300    8.8989    5.7620];

ufl = [629.9471  611.6782  593.7855  526.7789  460.6394  399.2741];

gaml = [6.5112    7.8116    6.2143   11.4325    7.5963    5.3239];

Afl = 1.0e+05 * [0.8563    0.2429    0.1484    1.3423    1.0094    1.1120];

%this should be working version over here lads

c = 299792458
l_ = uf./c
% lamb[m] = nu[s^-1]*c[m/s]
plot(l_, V_act);


function y = lin(params, x)
  y = params(1)*x + params(2);
end


[beta, covbeta] = nlinfit(l_, V_act, @lin, [1 0]);
hold on
plot(l_, V_act, '--');

hold off


beta