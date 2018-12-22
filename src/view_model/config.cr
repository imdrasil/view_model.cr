module ViewModel
  class Config
    macro template_engine(engine)
      class ::ViewModel::Config
        TEMPLATE_ENGINE = {{engine}}
      end
    end
  end
end
