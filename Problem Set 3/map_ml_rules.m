function [] = map_ml_rules(R1, B1, R2, B2, N)
%MAP_ML_RULES displays MAP and ML rules for given parameters
%   Urn I contains R 1 red balls and B 1 blue balls, and Urn II contains R 2 balls and B 2
%   blue balls. A ball is selected at random from Urn I and put into Urn II. Then a ball
%   from Urn II is selected. Based on the color of the ball chosen from Urn II, we try to
%   guess the color of the ball that was chosen from Urn I.

    red = 0;
    blue = 1;
    
    invert_decision = @(decision) ~(decision - 1) + 1;
    inverted_count = @(decision, r, b) ((r * ((invert_decision(decision) - 1) == red)) + ...
                        (b * ((invert_decision(decision) - 1) == blue)));
    thr_err = @(red_decision, blue_decision) (inverted_count(red_decision, R1, B1) / (R1 + B1)) * ...
                    (((invert_decision(red_decision) == (red + 1)) + R2) / (R2 + B2 + 1)) + ...
                    (inverted_count(blue_decision, R1, B1) / (R1 + B1)) * ...
                    (((invert_decision(blue_decision) == (blue + 1)) + B2) / (R2 + B2 + 1));
    est_err = @(outcomes, red_decision, blue_decision) (outcomes(invert_decision(red_decision), red + 1) + ...
                outcomes(invert_decision(blue_decision), blue + 1)) / N;
    
    disp("Determining MAP and ML Rules for:");
    disp("Urn I: " + R1 + " red ball(s) and " + B1 + " blue ball(s)");
    disp("Urn II: " + R2 + " red ball(s) and " + B2 + " blue ball(s)");
    
    disp(" ");
    
    urn1_outcomes = zeros(1, 2);
    urn1_urn2_outcomes = zeros(2);
    for i = 1:N
        urn1 = zeros(1, R1 + B1);
        urn1(1:B1) = blue;
        urn2 = zeros(1, R2 + B2 + 1);
        urn2(1:B2) = blue;
        
        urn1 = urn1(randperm(numel(urn1)));
        urn1_pick = urn1(randi(R1 + B1));
        
        urn2(end) = urn1_pick;
        
        urn2 = urn2(randperm(numel(urn2)));
        urn2_pick = urn2(randi(R2 + B2 + 1));
        
        urn1_outcomes(urn1_pick + 1) = urn1_outcomes(urn1_pick + 1) + 1;
        urn1_urn2_outcomes(urn1_pick + 1, urn2_pick + 1) = urn1_urn2_outcomes(urn1_pick + 1, urn2_pick + 1) + 1;
    end
    
    check = sum(urn1_urn2_outcomes, 2);
    assert(check(red + 1) == urn1_outcomes(red + 1));
    assert(check(blue + 1) == urn1_outcomes(blue + 1));
    
    urn2_outcomes = sum(urn1_urn2_outcomes, 1);
    
    [~, map_red_decision] = max(urn1_urn2_outcomes(:, red + 1) / urn2_outcomes(red + 1));
    [~, map_blue_decision] = max(urn1_urn2_outcomes(:, blue + 1) / urn2_outcomes(blue + 1));
    disp("MAP Rule:");
    if map_red_decision == red + 1
        disp("    Guess Red if Red");
    else
        disp("    Guess Blue if Red");
    end
    if map_blue_decision == red + 1
        disp("    Guess Red if Blue");
    else
        disp("    Guess Blue if Blue");
    end
    
    [~, ml_red_decision] = max(urn1_urn2_outcomes(:, red + 1) ./ urn1_outcomes');
    [~, ml_blue_decision] = max(urn1_urn2_outcomes(:, blue + 1) ./ urn1_outcomes');
    disp("ML Rule:");
    if ml_red_decision == red + 1
        disp("    Guess Red if Red");
    else
        disp("    Guess Blue if Red");
    end
    if ml_blue_decision == red + 1
        disp("    Guess Red if Blue");
    else
        disp("    Guess Blue if Blue");
    end
    
    disp(" ");
    
    map_thr_err = thr_err(map_red_decision, map_blue_decision);
    disp("MAP Theoretical Error: " + map_thr_err);
    
    ml_thr_err = thr_err(ml_red_decision, ml_blue_decision);
    disp("ML Theoretical Error: " + ml_thr_err);
    
    disp(" ");
    
    map_est_err = est_err(urn1_urn2_outcomes, map_red_decision, map_blue_decision);
    disp("MAP Estimated Error: " + map_est_err);
    
    ml_est_err = est_err(urn1_urn2_outcomes, ml_red_decision, ml_blue_decision);
    disp("ML Estimated Error: " + ml_est_err);
    
    disp(" ");
    disp(" ");
end