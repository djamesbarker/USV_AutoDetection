function [result, context] = compute(log, parameter, context)

% XBAT2RAVEN_V33 - compute

result = struct;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XBAT2Raven v3.3
%
% Makes Raven Selection Tables for all selected logs
%
% Note: Refreshes log.file and log.path to current log name and
%       current path
%
% designed for use in XBAT Pallet Log window
%
% Exports selected XBAT log to Raven selection table
%
% Ignores "Date Time" and "Time Stamp" attributes
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Michael Pitzrick
%  msp2@cornell.edu
%  21 Sep 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Changes:
%
%  1. All Raven selection tables go to the same directory (the default
%     directory for each log is log.path as XBAT logs)
%
%  2. All Raven selection tables output to the same directory.
%
%  3. If Raven selection table already exists, give user opportunity to
%  overwrite or rename.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% DISCLAIMER OF WARRANTIES

% THE SOFTWARE AND DOCUMENTATION ARE PROVIDED AS IS AND BRP MAKES NO
% REPRESENTATIONS OR WARRANTIES (WRITTEN OR ORAL). TO THE MAXIMUM EXTENT
% PERMITTED BY APPLICABLE LAW, BRP DISCLAIMS ALL WARRANTIES AND CONDITIONS,
% EXPRESS OR IMPLIED, AS TO ANY MATTER WHATSOEVER AND TO ANY PERSON OR
% ENTITY, INCLUDING, BUT NOT LIMITED TO, ALL IMPLIED WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND
% NON-INFRINGEMENT OF THIRD PARTY RIGHTS AND THOSE ARISING FROM A COURSE OF
% DEALING OR USAGE IN TRADE. NO WARRANTY IS MADE THAT ANY ERRORS OR DEFECTS
% IN THE SOFTWARE WILL BE CORRECTED, OR THAT THE SOFTWARE WILL MEET YOUR
% REQUIREMENTS.  END USERS SHALL NOT COPY OR REDISTRIBUTE THE SOFTWARE
% WITHOUT WRITTEN PERMISSION FROM BRP.

% LIMITATION OF LIABILITY

% IN NO EVENT SHALL BRP OR ITS DIRECTORS, FACULTY, OR EMPLOYEES, BE LIABLE
% FOR DAMAGES TO OR THROUGH YOU OR ANY OTHER PERSON OR ENTITY FOR BREACH
% OF, ARISING UNDER, OR RELATED TO THIS AGREEMENT OR THE USE OF SOFTWARE OR
% DOCUMENTATION PROVIDED HEREUNDER, UNDER ANY THEORY INCLUDING, BUT NOT
% LIMITED TO, DIRECT, SPECIAL, INCIDENTAL, INDIRECT, CONSEQUENTIAL, OR
% SIMILAR DAMAGES (INCLUDING WITHOUT LIMITATION, DAMAGES FOR LOSS OF
% BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION OR
% DATA, OR ANY OTHER LOSS) WHETHER FORESEEABLE OR NOT, REGARDLESS OF THE
% FORM OF ACTION, WHETHER IN CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT
% LIABILITY OR OTHERWISE.

%%

% initializations
if context.state.kill
    return;
end
