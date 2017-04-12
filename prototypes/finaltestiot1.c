void print_secure()
{
	int a=2;
	a=(a*2)+5;		
	int i;
	for(i=0;i<5;i++)
	{
		printf("Data\n");
	}
	
	
}

void verify()
{	
	char *rop="AAAAAAAAAAAAAAAABBBB\xdf\x82\x04\x08\xef\xbe\xad\xde\x43\x84\x04\x08";
	char buffer[4];
	strcpy(buffer,rop);
}
int main()
{
	verify();

}
