function fail(txt, dlg_name)

fprintf(2,'\n\n%s\n%s\n', dlg_name, txt);

h = warndlg(txt, dlg_name);

movegui(h, 'center')
