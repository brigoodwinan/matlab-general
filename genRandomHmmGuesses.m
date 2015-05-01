function [trguess,emitguess] = genRandomHmmGuesses(a,b)
% [TRGUESS,EMITGUESS] = genRandomHmmGuesses(a,b)
% [TRGUESS,EMITGUESS] = genRandomHmmGuesses(a)
%
% Brian Goodwin 2015-05-01
%
% 2015-05-01 -- v1
%
% Generates a matrix and vector containing random guesses at the
% transition and emission probabilities for HMMs.
%
% TRGUESS and EMITGUESS are initial estimates of the transition and 
% emission probability matrices. TRGUESS(i,j) is the estimated probability 
% of transition from state i to state j. EMITGUESS(i,k) is the estimated 
% probability that symbol k is emitted from state i.
%
% INPUTS:
% a: number of states for transition matrix and emission vector. If the
%     number of possible emissions is equal to the number of states, ignore
%     the second input.
% b: number of possible emissions.
%
% OUTPUTS:
% TRGUESS: a-by-a matrix of a guess of the transition probabilities.
% EMITGUESS: a-by-1 vector of a guess of the probability of that symbol 
%
% v1 Notes
% Currently, the code makes the first and last states non-emitting, so the
% emission matrix will have 0's for the first and last states.

if nargin<2
    b = a;
end

% Transition guesses
trguess = rand(a);
trguess = bsxfun(@rdivide,trguess,sum(trguess,2));

% Emission guesses
emitguess = rand(a,b);
emitguess = bsxfun(@rdivide,emitguess,sum(emitguess,2));