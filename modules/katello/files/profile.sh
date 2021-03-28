alias deleteerrors="foreman-rake foreman_tasks:cleanup TASK_SEARCH='result ~ error'  VERBOSE=true"
alias deletependings="foreman-rake foreman_tasks:cleanup TASK_SEARCH='state ~ pending'  VERBOSE=true"
alias deletewarnings="foreman-rake foreman_tasks:cleanup TASK_SEARCH='result ~ warning'  VERBOSE=true"
alias puppetinfra="puppet agent --config /etc/puppetlabs/infra/puppet.conf --onetime --test"
