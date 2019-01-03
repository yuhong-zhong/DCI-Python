#include "dci.h"
#include "util.h"
#include <stdio.h>
#include <malloc.h>
#include <assert.h>
#include <stdlib.h>

// generate the random seed
#include <inttypes.h>

dci test_master;

void main_dci_query(const int num_points, const int ambient_dim, const int num_query_points,
    const int num_neighbours, double* const data, double* const query, int* const final_outputs,
    double* const final_distances) {
    const int num_comp_indices = 2;
    const int num_simp_indices = 5;
    const int num_outer_iterations = 5000;
    const int max_num_candidates = 10 * num_neighbours;

    dci_init_master(&test_master, ambient_dim, num_comp_indices, num_simp_indices);
    dci_add_master(&test_master, ambient_dim, num_points, data);

    dci_query_config query_config = {false, num_outer_iterations, max_num_candidates};

    dci_master_query(&test_master, num_neighbours, &query_config, num_query_points, query, final_outputs, final_distances);
}

extern "C" {
    void python_dci_query(int num_points, int ambient_dim, int num_query_points,
        int num_neighbours, double* data, double* query, int* final_outputs,
        double* final_distances) {
        main_dci_query(num_points, ambient_dim, num_query_points,
        num_neighbours, data, query, final_outputs, final_distances);
    }
}
