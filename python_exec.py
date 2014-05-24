import sys

obj = compile(sys.argv[1], '', 'exec')
eval(obj, {'__builtins__': {'__import__':__builtins__.__import__}})