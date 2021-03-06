#ifndef __SEMAPHORE_H__
#define __SEMAPHORE_H__

#include <semaphore.h>

#include <iostream>

using namespace std;

class Semaphore {
public:
    Semaphore(int value) {
        sem_init(&sem, 0, value);
    }

    ~Semaphore() {
        sem_destroy(&sem);
    }

    void wait() {
        sem_wait(&sem);
    }

    void signal() {
        sem_post(&sem);
    }

    int get_value() {
        int value;
        sem_getvalue(&sem, &value);
        return value;
    }
private:
    sem_t sem;
};

#endif //__SEMAPHORE_H__
