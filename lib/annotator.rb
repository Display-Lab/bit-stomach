class Annotator

  def self.fork_annotation(annotator_path)
    child_pid = Process.fork do
      logger.info "forking Annotation"
      system("Rscript #{annotator_path}")
    end

    # Don't care about checking return status/reaping ourself.
    Process.detach(child_pid)
  end

  def self.thread_annotation(annotator_path)
    Thread.new do
      logger.info "Threading Annotation"
      system("Rscript #{annotator_path}")
    end
  end

end
