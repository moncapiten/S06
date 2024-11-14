clear all;
dataPosition = '../../Data/';


filenames = [];
for i = 1:6
    filenames = [filenames, strcat("data0", num2str(i + 18))];
end
color = [ "red", "#ffa500", "#777777", "green", "#0027bd", "#a020f0"];

mediaposition = '../../Media/';
medianame = 'AmplitudeOffsetIn';

flagSave = true;

% data import and creation of variance array


thr = 0.04;

Ri = 469.98;
Ro = 100.23 * 1e3;





function y = lin(params, x)
    y = params(1) * x + params(2);
end


for i = 1:length(filenames) 

    rawData = readmatrix(strcat(dataPosition, filenames(i), '.txt'));
    tt = rawData(:, 1);
    ch1 = rawData(:, 2);
    ch2 = rawData(:, 3);


    ii = [];
    io = [];
    for j = 1:length(ch1)
        if ch1(j) > thr
            ii = [ii, ch1(j) ];
            io = [io, ch2(j) ];
        end
    end

    p0 = [1, 0];
    [beta, r, ~, covbeta] = nlinfit(ii, io, @lin, p0);

    plot(ii, io, 'o', Color = color(i));
    if i == 1
        hold on
    end
    %plot(ii, lin(p0, ii), '--', 'Color', 'magenta');
    plot(ii, lin(beta, ii), '-', Color = color(i));


    beta;
end

hold off

























grid on
grid minor
%title('Amlitude and Offset of input signal');
%legend('Amplitude in - 4.5k divider', 'Offset in - 4.5k divider', 'Amplitude in - 45k divider', 'Offset in - 45k divider', Location= 'ne')
ylabel('Vi Amplitude [V]')
xlabel('frequency [Hz]')

hold off



if flagSave
    fig = gcf;
    orient(fig, 'landscape')
    print(fig, strcat(mediaposition, medianame, '.pdf'), '-dpdf')
end
