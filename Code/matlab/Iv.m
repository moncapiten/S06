clear all;

%d creating references to data and media files
dataPosition = '../../Data/';

filename = [];
for i = 1:7
    if ~(i==6)
        filename = [filename, strcat("data00", string(i))];
    end
end

mediaposition = '../../Media/';
medianame = 'LED2';

% plot and control variables

R = 469.98;
Ith = 7 * 1e-6;
I_act = [];
V_act = [];

flagSave = true;

color = [ "red", "#ffa500", "#ffff00", "green", "#0027bd", "#cc8899", "#a020f0"];
names = [ "red", "orange", "yellow", "green", "blue", "purple"];



% data import and plot
for i = 1:length(filename)
    swapRawData = readmatrix(strcat(dataPosition, filename(i), '.txt'));
    swapch1 = swapRawData(:, 2);
    swapch2 = swapRawData(:, 3);
    swapi = swapch1/R;
    semilogy(swapch2, swapi, '--', Color= color(i));
    if i == 1
        hold on
    end
    for i = 1:(length(swapi)-1)
        if ( (swapi(i)) <= Ith) && (swapi(i+1) > Ith)
            I_act = [I_act, swapi(i)];
            V_act = [V_act, swapch2(i)];
        end
    end
end

plot(linspace(1, 3, 100), repelem(Ith, 100), '-.', Color= 'black');


for i = 1:length(I_act)
    plot(V_act(i), I_act(i), 'x', Color= color(i));
end



grid on
grid minor
hold off

title('Iv plot for LEDs');
legend( [names, strcat("$ I_{th} = ", sprintf('%.2f', Ith * 1e6), " \mathrm{\mu A} $")], Location= 'nw', Interpreter='latex')
ylabel('I_V [A]');
xlabel('Voltage [V]');

xlim([1 3.2])
ylim([10^-7 10^-2]);

fontsize(gcf, 14,"points")

I_act
V_act

% media save
if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
