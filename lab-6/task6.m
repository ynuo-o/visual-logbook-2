% Lab 6 Task 6 - Object recognition using webcam and neural networks
clear all; close all;

%% ===== Part 1: Single image classification =====

camera = webcam;
net = squeezenet;                              % try also: alexnet, squeezenet
inputSize = net.Layers(1).InputSize(1:2);

figure(1);
I = snapshot(camera);
image(I);
f = imresize(I, inputSize);

tic;
[label, score] = classify(net, f);
t = toc;

title({char(label), ...
       sprintf('Score: %.2f', max(score)), ...
       sprintf('Time: %.3f sec', t)});

fprintf('Label: %s\n', char(label));
fprintf('Confidence: %.2f%%\n', max(score)*100);
fprintf('Time taken: %.3f seconds\n', t);

%% ===== Part 2: Try different networks and compare =====
networks = {'googlenet', 'alexnet', 'squeezenet'};

figure(2);
I = snapshot(camera);

for i = 1:length(networks)
    try
        net_i = eval(networks{i});
        inputSize_i = net_i.Layers(1).InputSize(1:2);
        f_i = imresize(I, inputSize_i);
        tic;
        [label_i, score_i] = classify(net_i, f_i);
        t_i = toc;
        fprintf('%s: %s (%.2f%%) in %.3f sec\n', ...
                networks{i}, char(label_i), max(score_i)*100, t_i);
    catch
        fprintf('%s not installed\n', networks{i});
    end
end

%% ===== Part 3: Continuous loop =====
figure(3);
disp('Press Ctrl+C to stop');

while true
    I = snapshot(camera);
    f = imresize(I, inputSize);
    tic;
    [label, score] = classify(net, f);
    t = toc;
    image(I);
    title({char(label), ...
           sprintf('Score: %.2f%%', max(score)*100), ...
           sprintf('Time: %.3f sec', t)});
    drawnow;
end