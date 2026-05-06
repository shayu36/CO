#include <stdio.h>
#include <math.h>
#include <string.h>
#include <stdlib.h>
int binfind(long long a[], long long key, int low, int high)
{
    int mid;
    while (low <= high)
    {
        mid = (low + high) / 2;
        if (key == a[mid])
            return mid;
        else if (key > a[mid])
            low = mid + 1;
        else
            high = mid - 1;
    }
    return -1;
}
long long xh[100005];
char xm[100005][25];
int main()
{
    int n, m;
    scanf("%d%d", &n, &m);

    for (int i = 0; i < n; i++)
    {
        scanf("%lld", &xh[i]);
        getchar();
        fgets(xm[i], sizeof(xm[i]), stdin);
        xm[i][strcspn(xm[i], "\n")] = '\0';
    }
    for (int i = 0; i < m; i++)
    {
        long long a;
        scanf("%lld", &a);
        if (binfind(xh, a, 0, n - 1) != -1)
        {
            printf("%s\n", xm[binfind(xh, a, 0, n - 1)]);
        }
        else
            printf("Not find!\n");
    }
}