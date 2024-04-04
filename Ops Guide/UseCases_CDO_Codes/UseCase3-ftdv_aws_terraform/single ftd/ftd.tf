module "ftdv_in_cdo" {
  source              = "./modules/cdo/ftd"
  vpc_id              = module.cdo_provider_example_vpc.vpc_id
  public_subnet_id    = module.cdo_provider_example_vpc.public_subnet_id
  private_subnet_id   = module.cdo_provider_example_vpc.private_subnet_id
  ftd_name            = var.ftd_01_hostname
  cdo_api_token       = var.cdo_api_token
}