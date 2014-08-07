function value = is_method(value, name)

value = string_is_member(name, methods(value));
