module UIControlWrap
  # adds ability to trigger a defined callback
  # that was previously defined by #when
  def trigger(events)
    @callback ||= {}
    @callback[events].map(&:call) if @callback.has_key? events
  end
end