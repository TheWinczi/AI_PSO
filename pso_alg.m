% --------------------------------
% PSO algorithm implementation
% --------------------------------


function [] = pso_alg(particles_size, iterations, w)

    % prezentacja funkcji, ktorej minimum szukamy
    [x, y] = meshgrid(-5:0.05:5);
    z = funea(x, y);
    surf(x, y, z);

    % tworzenie czatek i ich polozen poczatkowych
    % particles_size = 20;
    % w = 10*rand(particles_size, 2) - 5;

    % iterations = 50;
    it_nb = 1;

    minims = [];

    actual_speeds = zeros(iterations+1, 2*particles_size);
    for i = 1:particles_size
        start_speed = 10 * rand(1, 2) - 5;
        actual_speeds(1, (i-1)*2+1) = start_speed(1);
        actual_speeds(1, (i-1)*2+2) = start_speed(2);
    end

    histories = zeros(iterations+1, particles_size*2);
    for i = 1:particles_size
        histories(1, (i-1)*2+1) = w(i, 1);
        histories(1, (i-1)*2+2) = w(i, 2);
    end

    contour(x, y, z, 10);
    hold on;
    plot(w(:, 1), w(:, 2), 'ko');
    title('Start positions');
    hold off;
    pause;

    max_x_speed = 0.5 * (5 - (-5));
    max_y_speed = 0.5 * (5 - (-5));
    time = 0;
    min_val = 99999;
    % glowna petla do wyznaczania minimum funkcji w maksymalnie 1000 iteracji
    for iter = 1:iterations
        
        tic;
        [val, ind] = min(funea(w(:,1),w(:,2)));
        if val < min_val
            best_point = [w(ind, 1), w(ind, 2)];
            min_val = val;
        end

        for i = 1:particles_size

            % wyznaczenie wektora do najlepszego punktu dla całego roju
            [best_vec_x, best_vec_y] = get_vector(w(i, 1), w(i, 2), best_point(1), best_point(2));

            % wyznaczenie wektora do najlepszego punktu i-tego osobnika
            [val, ind] = min(funea(histories(1:it_nb,(i-1)*2+1), histories(1:it_nb, (i-1)*2+2)));
            best_in_history = [histories(ind, (i-1)*2+1), histories(ind, (i-1)*2+2)];        
            [best_hist_vec_x, best_hist_vec_y] = get_vector(w(i, 1), w(i, 2), best_in_history(1), best_in_history(2));

            best_hist_vec_x = best_hist_vec_x * 1/(it_nb/5);
            best_hist_vec_y = best_hist_vec_y * 1/(it_nb/5);

            % wyznaczenie aktualnego wektora i-tego osobnika
            [new_vec_x, new_vec_y] = add_vectors(best_hist_vec_x, best_hist_vec_y, best_vec_x, best_vec_y, actual_speeds(it_nb, (i-1)*2+1), actual_speeds(it_nb, (i-1)*2+2));

            new_vec_x = new_vec_x * (0.5 + 0.5/(iterations - (it_nb-1)));
            new_vec_y = new_vec_y * (0.5 + 0.5/(iterations - (it_nb-1)));

            % zapisanie wyznaczonych wartosci
            histories(it_nb+1, (i-1)*2+1) = new_vec_x + w(i, 1);
            histories(it_nb+1, (i-1)*2+2) = new_vec_y + w(i, 2);

            actual_speeds(it_nb+1, (i-1)*2+1) = new_vec_x;
            actual_speeds(it_nb+1, (i-1)*2+2) = new_vec_y;

            % aktualizacja wspolrzednych osobnikow
            w(i, 1) = w(i, 1) + new_vec_x;
            w(i, 2) = w(i, 2) + new_vec_y;
        end
        
        time = time + toc;
        
        fig_title = "Iteration number " + num2str(it_nb);
        contour(x, y, z, 10);
        hold on;
        plot(w(:, 1), w(:, 2), 'ko');
        title(fig_title);
        hold off;
        pause;

        minims(it_nb) = min_val;
        
        [it_nb , min(funea(w(:, 1), w(:, 2))), best_point(1), best_point(2)]
        it_nb = it_nb + 1;
    end
    
    text = "Sum of needed time " + num2str(iterations) + " iterations: " + num2str(time);
    disp(text);
    plot(1:iterations, minims);
    xlabel('Number of iteration');
    ylabel('Lowest value of the swarm');
    title('Algorith summary');

    % Funkcja do wyznaczania wektora AB z punktu A do B
    function [x, y] = get_vector(x1, y1, x2, y2)
        x = x2 - x1;
        y = y2 - y1;
    end

    % Funkcja do sumowania 3 wektorów
    function [x, y] = add_vectors(x1, y1, x2, y2, x3, y3)
        x = x1 + x2 + x3;
        y = y1 + y2 + y3;
    end
end
