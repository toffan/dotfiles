flags = [
    '-Wall',
    '-Wextra',
    '-std=c++14',
    # '-stdlib=libc++',
    '-x', 'c++',
    '-I', '.',
    '-I', 'include',
    '-isystem', '/usr/include/c++/6.3.1/',
    '-isystem', '/usr/include'
]


def FlagsForFile(filename):
    return {
        'flags': flags,
        'do_cache': True
    }
